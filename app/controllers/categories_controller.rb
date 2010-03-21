class CategoriesController < ApplicationController
  # GET /categories
  # GET /categories.xml
  before_filter :verify_admin_status
  
  def index
    @categories = Category.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.fbml # index.fbml.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])
    @categories = Category.find(:all)

    respond_to do |format|
      format.html # show.html.erb
      format.fbml # show.fbml.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.fbml # new.fbml.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(categories_url) }
        format.fbml { redirect_to(categories_url) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        flash[:notice] = 'Cannot created the category.'
        format.html { render :action => "new" }
        format.fbml { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(categories_url) }
        format.fbml { redirect_to(categories_url) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Cannot modify the category.'
        format.html { render :action => "edit" }
        format.fbml { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:notice] = 'Category was successfully deleted.'
    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.fbml { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end
end
