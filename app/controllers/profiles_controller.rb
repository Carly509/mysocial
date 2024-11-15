class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:show, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @posts = @profile.user.posts.order(created_at: :desc).includes(:user)
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to @profile, notice: 'Profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def ensure_correct_user
    unless @profile.user == current_user
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def profile_params
    params.require(:profile).permit(:username, :bio, :avatar)
  end
end
