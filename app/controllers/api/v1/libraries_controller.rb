class Api::V1::LibrariesController < ApiController
	before_action :check_for_valid_authtoken
	before_action :set_library, only: [:show, :edit, :update, :destroy, :purchase]
	skip_before_action :verify_authenticity_token
	after_action  :verify_authorized

	def index
		@libraries = Library.all
		# binding.pry
		render :status => 400,
		      	:json => {:message => 'all', :library => @libraries}
	end

	def show
		authorize @library
	end

	def new
		@library = Library.new
	end

	def edit
	end

	def create
		@library = Library.new(library_params)
		@library.created_by = @user.id
		
		authorize @library
		# LibraryPolicy.new(@user, @library).create?

		if @library.save
			render :status => 400,
		      	:json => {:message => 'created', :library => @library}
		else
			render :status => 400,
	      	:json => {:message => @library.errors.full_messages}
		end
	end

	def update
		authorize @library
		if @library.update(library_params)
		render :status => 400,
	      	:json => {:message => 'updated', :library => @library}
		else
			render :status => 400,
	      	:json => {:message => 'not updated'}
		end
	end

	def destroy
		@library.destroy
		render :status => 400,
	      	:json => {:message => 'updated', :library => @library}
	end

	def purchase
		@library.update_attributes(:purchased_on => Date.today, :in_possession_of => @library.user.id)
		render :status => 400, :json => {:message => 'Purchased', :library => @library}
	end

	private
	def set_library
		@library = Library.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def library_params
		# params.permit(:name)
		params.permit(:name, :created_by)
	end
end