class UserListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_listing, only: %i[show destroy]

  # GET /listings or /listings.json
  def index
    @user_listing = UserListing.new
    @user_listings = UserListing.all
  end

  # GET /listings/1 or /listings/1.json
  def show
    @chart_labels = %w[January February March April] # TODO: ADD CHART DATA
    @chart_data = [10, 20, 30, 40] # TODO: ADD CHART DATA
  end

  # POST /listings or /listings.json
  def create
    @user_listing = current_user.user_listings.create user_listing_params
    @user_listings = UserListing.all

    respond_to do |format|
      if @user_listing.save
        ScraperJob.perform_async(user_listing_params[:url], @user_listing.id)
        format.html do
          redirect_to user_listings_path, notice: 'Listing was successfully created and will shortly be added.'
        end
      else
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1 or /listings/1.json
  def destroy
    @user_listing.listing.destroy! if @user_listing.listing.user_listings.count == 1
    @user_listing.destroy!

    respond_to do |format|
      format.html { redirect_to listings_path, status: :see_other, notice: 'Listing was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_listing
    @user_listing = UserListing.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_listing_params
    params.require(:user_listing).permit(:url, :user_id, :pending).with_defaults(pending: true)
  end
end
