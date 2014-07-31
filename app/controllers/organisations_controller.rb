class OrganisationsController < ApplicationController

	before_action :authenticate_user!

	def new
		@user = current_user
		@organisation = @user.organisations.new
	end

	def create
	
		organisation  = Organisation.new organisation_params
		organisation.users << current_user
		organisation.save

		redirect_to organisation_path(organisation)
	end

	def show
		@organisation = Organisation.find params[:id]
	end

	def update
		@organisation = Organisation.find params[:id]
		[:name, :short_bio, :profession, :network, :workSelection].each do |attr|
			if params[attr]
				@organisation.update!(attr => params[attr])
			end
		end

		if params[:file]
			@organisation.update!(image: params[:file])
		else
			@organisation.update(image_params)
		end

		redirect_to user_path(id: current_user.id, editable: true)
	end


	private

	def organisation_params
		params.require(:organisation).permit(:name, :description, :network, :organisation_type, :image, :creator_role)
	end

	def avatar_params
		params[:organisation].permit(:image)
	end

end
