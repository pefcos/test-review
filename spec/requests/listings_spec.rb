require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/listings", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Listing. As you add validations to Listing, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Listing.create! valid_attributes
      get listings_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      listing = Listing.create! valid_attributes
      get listing_url(listing)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      listing = Listing.create! valid_attributes
      get edit_listing_url(listing)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Listing" do
        expect {
          post listings_url, params: { listing: valid_attributes }
        }.to change(Listing, :count).by(1)
      end

      it "redirects to the created listing" do
        post listings_url, params: { listing: valid_attributes }
        expect(response).to redirect_to(listing_url(Listing.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Listing" do
        expect {
          post listings_url, params: { listing: invalid_attributes }
        }.to change(Listing, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post listings_url, params: { listing: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested listing" do
        listing = Listing.create! valid_attributes
        patch listing_url(listing), params: { listing: new_attributes }
        listing.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the listing" do
        listing = Listing.create! valid_attributes
        patch listing_url(listing), params: { listing: new_attributes }
        listing.reload
        expect(response).to redirect_to(listing_url(listing))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        listing = Listing.create! valid_attributes
        patch listing_url(listing), params: { listing: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested listing" do
      listing = Listing.create! valid_attributes
      expect {
        delete listing_url(listing)
      }.to change(Listing, :count).by(-1)
    end

    it "redirects to the listings list" do
      listing = Listing.create! valid_attributes
      delete listing_url(listing)
      expect(response).to redirect_to(listings_url)
    end
  end
end
