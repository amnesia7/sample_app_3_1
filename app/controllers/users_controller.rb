class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy

  require 'will_paginate'

  def index
    @title = "All Users"
    @users = User.paginate(:page => params[:page])
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
  	@title = @user.name
  end

  def new
  	@user = User.new
  	@title = "Sign Up"
    redirect_to root_path if signed_in?
  end

  def create
    redirect_to root_path and return if signed_in? # requires return to end action
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		@title = "Sign Up"
      @user.password = ""
      @user.password_confirmation = ""
  		render 'new'
  	end
  end

  def edit
    @title = "Edit User"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = "Edit User"
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user == @user
      flash[:notice] = "You cannot delete yourself"
    else
      @user.destroy
      flash[:success] = "User destroyed"
    end
    redirect_to users_path
  end

  def following
    show_follow(:following)
  end

  def followers
    show_follow(:followers)
  end

  def show_follow(action)
    @title = action.to_s.capitalize
    @user = User.find(params[:id])
    @users = @user.send(action).paginate(:page => params[:page])
    render 'show_follow'
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
