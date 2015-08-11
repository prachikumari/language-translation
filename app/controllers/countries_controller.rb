class CountriesController < ApplicationController
 load_and_authorize_resource

 def new
   @country = Country.new
 end

 def edit
   @country = Country.find(params[:id])
 end

 def index
   if current_user.has_role? :superadmin
     @countries = Country.all.page(params[:page]).per(20)
   else
     @countries = current_user.organization.countries.page(params[:page]).per(20)
   end
 end

 def show
   @country = Country.find(params[:id])
 end

 def destroy
  @country = Country.find(params[:id])
  @country.destroy
 
  redirect_to countries_path
 end

 def update
   @country = Country.find(params[:id])
 
  if @country.update(country_params)
        redirect_to @country
  else
    render 'edit'
  end
 end

 def create
     @country = Country.new(country_params)
     @country.organization_id = current_user.organization.id
	 
     if @country.save
        redirect_to @country
     else
        render 'new'
     end
 end

 private
   def country_params
       params.require(:country).permit(:name, :user_id, :organization_id)
   end
end
