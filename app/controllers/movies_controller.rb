class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ["G", "PG", "PG-13", "R"]
    
    @select_rate = {}
    
    @all_ratings.map {|i| @select_rate[i] = "1"}

    if params[:ratings] == nil
      if session[:ratings] != nil
        @select_rate = session[:ratings]
      else
      session[:ratings] = @select_rate
     end
    else
      if params[:ratings]!= session[:ratings]
        session[:ratings] = params[:ratings]
        @select_rate = params[:ratings]
      else
        @select_rate = session[:ratings]
      end
    end
    
    if params[:order] != nil
      session[:order] = params[:order]
      @select_rate = session[:ratings]
    end

    

    if session[:order] == "title"
      @name1 = "hilite"
      @name2 = ""
    elsif session[:order] == "release_date"
      @name1 = ""
      @name2 = "hilite"  
    else
      @name1 = ""
      @name2 = ""
    end
    @movies = Movie.find(:all, :conditions => { :rating => @select_rate.keys }, :order => session[:order])
    end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end