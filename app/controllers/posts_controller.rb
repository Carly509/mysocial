class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:user, :likes, media_attachments: :blob)
                 .order(created_at: :desc)
                 .page(params[:page]).per(20)
    @post = current_user.posts.build
  end

  def show
    @comment = @post.comments.build
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to root_path, notice: 'Post was successfully created.'
    else
      @posts = Post.order(created_at: :desc).page(params[:page])
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path, notice: 'Post was successfully deleted.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_correct_user
    unless @post.user == current_user
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def post_params
    params.require(:post).permit(:content, media_files: [])
  end
end
