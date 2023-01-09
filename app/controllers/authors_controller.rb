class AuthorsController < ApplicationController

    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    def index 
        user = User.find(session[:user_id])
        authors = user.authors.uniq
        render json: authors
    end

    def show
        author = Author.find(params[:id])
        render json: author
    end

    def create 
        author = Author.create!(author_params)
        render json: author, status: :created
    end

    def update 
        author = Author.find(params[:id])
        author.update!(author_params)
    end

    def destroy
        author = Author.find(params[:id])
        author.destroy 
        head :no_content
    end

    private

    def author_params
        params.permit(:id, :title, :year_establisher, :primary_genre, :image)
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

    def render_not_found_response
        render json: { error: 'Author not found' }, status: :not_found 
    end
end