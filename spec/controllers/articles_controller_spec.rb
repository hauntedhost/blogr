require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let(:article) { create(:article) }
  let(:author) { create(:user, session_key: 123) }
  let(:article_params) { attributes_for(:article) }
  let(:invalid_article_params) {
    empty_key = [:title, :body].sample
    article_params.tap { |params| params[empty_key] = '' }
  }

  describe 'POST #create' do
    context 'without a logged in user' do
      it 'redirects to login page' do
        post :create, article: article_params
        expect(response).to redirect_to login_path
      end
    end

    context 'with a logged in user' do
      before(:each) {
        session[:session_key] = author.session_key
      }

      context 'with valid attributes' do
        it 'saves the article' do
          expect {
            post :create, article: article_params
          }.to change(Article, :count).by(1)
        end

        it 'redirects to the article' do
          post :create, article: article_params
          expect(response).to redirect_to(article_path(assigns(:article)))
        end
      end

      context 'with invalid attributes' do
        it 'does not save the article' do
          expect {
            post :create, article: invalid_article_params
          }.not_to change(Article, :count)
        end

        it 're-renders the :new template' do
          post :create, article: invalid_article_params
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'without a logged in user' do
      it 'redirects to login page' do
        get :edit, id: article
        expect(response).to redirect_to login_path
      end
    end

    context 'with a logged in user' do
      let!(:article) { create(:article) }

      before(:each) {
        session[:session_key] = author.session_key
      }

      it 'deletes the article' do
        expect {
          delete :destroy, id: article
        }.to change(Article, :count).by(-1)
      end

      it 'redirects to articles#index' do
        delete :destroy, id: article
        expect(response).to redirect_to articles_path
      end
    end
  end

  describe 'GET #edit' do
    context 'without a logged in user' do
      it 'redirects to login page' do
        get :edit, id: article
        expect(response).to redirect_to login_path
      end
    end

    context 'with a logged in user' do
      before(:each) {
        session[:session_key] = author.session_key
      }

      it 'assigns the article' do
        get :edit, id: article
        expect(assigns(:article)).to eq(article)
      end

      it 'renders the :edit template' do
        get :edit, id: article
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET #index' do
    let!(:articles) { create_list(:article, 3) }

    it 'populates an array of all contacts' do
      get :index
      expect(assigns(:articles)).to match_array(articles)
    end

    it 'renders the :index template with articles' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    let!(:article) { create(:article) }

    it 'assigns the article' do
      get :show, id: article
      expect(assigns(:article)).to eq(article)
    end

    it 'renders the :show template with the article' do
      get :show, id: article
      expect(response).to render_template(:show)
    end
  end

  describe 'PATCH #update' do
    let!(:article) { create(:article) }

    context 'without a logged in user' do
      it 'redirects to login page' do
        patch :update, id: article.id, article: attributes_for(:article)
        expect(response).to redirect_to login_path
      end
    end

    context 'with a logged in user' do
      before(:each) {
        session[:session_key] = author.session_key
      }

      context 'with valid attributes' do
        let(:article_params) {
          attributes_for(:article).tap { |params|
            params[:title] = 'Updated Article Title'
            params[:body] = 'Update article body'
          }
        }

        it 'assigns the article' do
          patch :update, id: article.id, article: article_params
          expect(assigns(:article)).to eq(article)
        end

        it 'updates the article' do
          patch :update, id: article.id, article: article_params
          article.reload
          expect(article.title).to eq(article_params[:title])
          expect(article.body).to eq(article_params[:body])
        end

        it 'redirects to the article' do
          patch :update, id: article.id, article: article_params
          expect(response).to redirect_to(article_path(assigns(:article)))
        end
      end

      context 'with invalid attributes' do
        let(:invalid_article_params) {
          article_params.tap { |params|
            params[:title] = 'Article Missing Body'
            params[:body] = ''
          }
        }

        it 'does not update the article' do
          old_body = article.body
          patch :update, id: article.id, article: invalid_article_params
          article.reload
          expect(article.title).not_to eq(invalid_article_params[:title])
          expect(article.title).not_to eq(invalid_article_params[:body])
          expect(article.body).to eq(old_body)
        end

        it 're-renders the :edit template' do
          patch :edit, id: article.id, article: invalid_article_params
          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
