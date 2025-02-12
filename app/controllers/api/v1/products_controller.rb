class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!, only: %i[ index show ]
  before_action :authenticate_admin!, except: %i[ index show ]
  before_action :set_product, only: %i[ show update update_state destroy ]
  before_action :required_brand_active!, only: %i[ create update update_state destroy ]

  # GET /products
  def index
    authorize Product
    pagy, @products = pagy(policy_scope(Product).includes(:brand))

    render json: {
      pagination: PagySerializer.new(pagy).serializable_hash[:data],
      **product_json(@products)
    }
  end

  # GET /products/1
  def show
    authorize @product
    render json: product_json(@product)
  end

  # POST /products
  def create
    @product = Product.new(product_params)
    @product.owner = current_user

    authorize @product

    if @product.save
      render json: product_json(@product), status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    authorize @product

    if @product.update(product_params)
      render json: product_json(@product)
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/products/1/update_state
  def update_state
    authorize @product

    result = UpdateProductStateService.new.update(product: @product, state: update_state_params[:state])
    if result.success
      render json: product_json(result.product)
    else
      render json: { errors: Array.wrap(result.errors) }, status: :unprocessable_entity
    end
  rescue => e
    render :bad_request
  end

  # DELETE /products/1
  def destroy
    authorize @product

    @product.destroy!
    head :no_content
  end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:brand_id, :name, :price, :currency)
    end

    def update_state_params
      params.require(:product).permit(:state)
    end

    def product_json(product_data)
      ProductSerializer.new(product_data, { include: [ :brand ] }).serializable_hash
    end

    def required_brand_active!
      raise ActiveRecord::RecordInvalid if (@product&.brand || Brand.find(product_params[:brand_id])).inactive?
    end
end
