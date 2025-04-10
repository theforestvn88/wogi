class Api::V1::BrandsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_brand, only: %i[ show update update_state destroy ]

  # GET /api/v1/brands
  def index
    authorize Brand
    @brands = Rails.cache.fetch("brands", expires_in: 1.hour) do
      Brand.includes(:owner).all
    end

    render json: brand_json(@brands)
  end

  # GET /api/v1/brands/1
  def show
    authorize @brand
    render json: brand_json(@brand)
  end

  # POST /api/v1/brands
  def create
    @brand = Brand.new(brand_params)
    @brand.owner = current_user

    authorize @brand

    if @brand.save
      render json: brand_json(@brand), status: :created
    else
      render json: @brand.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/brands/1
  def update
    authorize @brand

    if @brand.update(brand_params)
      render json: brand_json(@brand)
    else
      render json: @brand.errors, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/brands/1/update_state
  def update_state
    authorize @brand

    result = UpdateBrandStateService.new.update(brand: @brand, state: update_state_params[:state])
    if result.success
      render json: brand_json(@brand)
    else
      render json: { errors: Array.wrap(result.errors) }, status: :unprocessable_entity
    end
  rescue
    render :bad_request
  end

  # DELETE /api/v1/brands/1
  def destroy
    authorize @brand
    @brand.destroy!
    head :no_content
  end

  private

    def set_brand
      @brand = Brand.find(params[:id])
    end

    def brand_params
      params.require(:brand).permit(:name)
    end

    def update_state_params
      params.require(:brand).permit(:state)
    end

    def brand_json(brand_data)
      BrandSerializer.new(brand_data, { include: [ :owner ] }).serializable_hash.to_json
    end
end
