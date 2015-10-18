class ArticlesController < ApplicationController
  before_action :require_user!, only: [:create, :edit, :update]

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to article_path(@article), notice: 'Article Created'
    else
      flash.now[:error] = @article.errors.full_messages.to_sentence
      render :new, locals: { article: @article }
    end
  end

  def destroy
    article.destroy
    redirect_to articles_path, notice: 'Article Deleted'
  end

  def edit
    render :edit, locals: { article: article }
  end

  def index
    respond_to do |format|
      format.html { render :index, locals: { articles: articles } }
      format.csv { send_csv articles }
      format.json { render json: articles }
    end
  end

  def show
    render :show, locals: { article: article }
  end

  def update
    if article.update_attributes(article_params)
      redirect_to article_path(article), notice: 'Article Updated'
    else
      flash.now[:error] = article.errors.full_messages.to_sentence
      render :edit, locals: { article: article }
    end
  end

  private

  def article
    @article ||= Article.find(params[:id])
  end

  def articles
    @articles ||= if params[:user_id]
      Article.where(author_id: params[:user_id])
    else
      Article.all
    end
  end

  def article_params
    params.require(:article).permit(:title, :body)
  end
end
