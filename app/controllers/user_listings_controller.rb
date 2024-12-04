class UserListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_listing, only: %i[show destroy]

  # GET /listings or /listings.json
  def index
    @user_listing = UserListing.new
    @user_listings = current_user.user_listings.all
  end

  # GET /listings/1 or /listings/1.json
  def show
    grouped_data = @user_listing.listing.reviews.order(:created_at).group_by { |r| r.created_at.strftime('%B %Y') }
    @chart_labels = grouped_data.keys
    @chart_values = grouped_data.values.map(&:count)
    @review_sample = @user_listing.listing.reviews.sample 8
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
    @user_listing.destroy!

    respond_to do |format|
      format.html { redirect_to user_listings_path, status: :see_other, notice: 'Listing was successfully destroyed.' }
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
