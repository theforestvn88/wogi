shared_examples "customable" do
    it { should have_many(:custom_fields) }
end
