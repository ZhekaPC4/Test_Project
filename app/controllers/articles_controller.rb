class ArticlesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :is_admin_or_editor, except: [:index, :show]
  
  def index
    @articles = Article.order(id: :desc).page(params[:page]).per(5)
  end

  def show
    @article = Article.find(params[:id])
  end
  
  def new
  end

  def delete
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to main_page_path
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update({title: article_params[:title], text: article_params[:text]})
    if @article.save
      redirect_to main_page_path
    else 
      redirect_to article_edit_path
      flash[:update_error] = "Ошибка изменения"
    end
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to article_by_id_path(@article.id)
    else 
      flash[:new_article_error] = "Слишком короткое навзание или содержание статьи"
      redirect_to article_new_path
    end
  end
  
  def cms
    @articles = Article.order(id: :desc).page(params[:page]).per(15)
  end

  private
  def article_params
    new_params = params.require(:article).permit(:title, :text, :author_id)
  end

end
