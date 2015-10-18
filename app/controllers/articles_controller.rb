class ArticlesController < ApplicationController
  before_action :require_user!, only: [:create, :edit, :update]
  before_action :set_article, only: [:destroy, :edit, :show, :update]

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
    @article.destroy
    redirect_to articles_path, notice: 'Article Deleted'
  end

  def edit
    render :edit, locals: { article: @article }
  end

  def index
    @articles = Article.all
    render :index, locals: { articles: @articles }
  end

  def show
    render :show, locals: { article: @article}
  end

  def update
    if @article.update_attributes(article_params)
      redirect_to article_path(@article), notice: 'Article Updated'
    else
      flash.now[:error] = @article.errors.full_messages.to_sentence
      render :edit, locals: { article: @article }
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :body)
  end
end
