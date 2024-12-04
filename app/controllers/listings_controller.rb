class ListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing, only: %i[show destroy]

  # GET /listings or /listings.json
  def index
    @listing = Listing.new
    @listings = Listing.all
  end

  # GET /listings/1 or /listings/1.json
  def show
    @review_data = @listing.reviews.group_by { |r| r.created_at.strftime('%B %Y') }
    @chart_labels = grouped_data.keys
    @chart_values = grouped_data.values.map(&:count)
  end

  # POST /listings or /listings.json
  def create
    @listing = Listing.new(listing_params)

    respond_to do |format|
      if @listing.save
        ScraperJob.perform_async(@listing.url)

        format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1 or /listings/1.json
  def destroy
    @listing.destroy!

    respond_to do |format|
      format.html { redirect_to listings_path, status: :see_other, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_listing
    @listing = Listing.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def listing_params
    params.require(:listing).permit(:url, :user_id)
  end
end
