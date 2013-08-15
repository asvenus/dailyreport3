class CatalogsController < ApplicationController
	#before_action :admin_user,   only: [:index,:show ,:edit, :update, :destroy]
	def new
		@catalog = Catalog.new
	end

	def create
		@catalog = Catalog.new(catalog_params)
		if @catalog.save
			flash[:success] = "A new questions created successfull"
			redirect_to catalogs_path
		else 
			render 'new'
		end

	end

	def index
		@catalogs = Catalog.paginate(page: params[:page], per_page: "6")
	end

	def show
		@group = Group.find(params[:id])
		@catalogs = Catalog.all(:conditions => {group_id: @group.id})
	end


	def edit
		 @catalog = Catalog.find(params[:id])
	end

	def update
		@catalog = Catalog.find(params[:id])
		if @catalog.update_attributes(catalog_params)
 			#Handle a successfill update
 			flash[:success] = "questions updated"
 			redirect_to catalogs_path	
 		else
 			render 'edit'
 		end
 	end


	def destroy
	  	@catalog = Catalog.find(params[:id])
  		@catalog.destroy
  		flash[:success] = "Question deleted!"
  		redirect_to catalogs_url
	end

	private
		def catalog_params
			params.require(:catalog).permit(:content,:group_id,:required)
		end

end

