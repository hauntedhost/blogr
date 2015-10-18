require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let(:user) { create(:user, session_key: 123) }
  let(:article) { create(:article, author: user) }
  let(:article_params) { attributes_for(:article) }
  let(:invalid_article_params) {
    empty_key = [:title, :body].sample
    article_params.tap { |params| params[empty_key] = '' }
  }

  shared_examples 'can read articles' do
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

      context 'given CSV format request' do
        it 'returns a CSV file' do
          get :index, format: :csv
          expect(response.headers['Content-Type']).to match('text/csv')
        end

        it 'returns CSV content' do
          get :index, format: :csv
          header = Article.column_names.join(',')
          article = assigns(:articles).first
          expect(response.body).to match(header)
          expect(response.body).to match("#{article.title},#{article.body}")
        end
      end

      context 'given JSON format request' do
        it 'returns JSON' do
          get :index, format: :json
          articles = assigns(:articles)
          expect(response.body).to eq(articles.to_json)
        end
      end

      context 'GET /users/:user_id/articles' do
        it 'returns articles for the given user' do
          author1 = create(:user)
          articles1 = create_list(:article, 3, author: author1)

          author2 = create(:user)
          articles2 = create_list(:article, 3, author: author2)

          get :index, user_id: author1.id
          articles = assigns(:articles)

          expect(articles).to match_array(articles1)
          expect(articles).not_to include(articles2)
        end
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
  end

  shared_examples 'cannot create or manage articles' do
    describe 'POST #create' do
      it 'redirects to login page' do
        post :create, article: article_params
        expect(response).to require_login
      end
    end

    describe 'DELETE #destroy' do
      it 'redirects to login page' do
        get :edit, id: article
        expect(response).to require_login
      end
    end

    describe 'GET #edit' do
      it 'redirects to login page' do
        get :edit, id: article
        expect(response).to require_login
      end
    end

    describe 'GET #new' do
      it 'redirects to login page' do
        get :new
        expect(response).to require_login
      end
    end

    describe 'PATCH #update' do
      it 'redirects to login page' do
        patch :update, id: article.id, article: attributes_for(:article)
        expect(response).to require_login
      end
    end
  end

  shared_examples 'can create new articles' do
    describe 'POST #create' do
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

    describe 'GET #new' do
      it 'assigns a new contact' do
        get :new
        expect(assigns(:article)).to be_a_new(Article)
      end

      it 'renders the :new template' do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  shared_examples 'can manage authored articles only' do
    describe 'DELETE #destroy' do
      context 'when user does not own article' do
        let!(:article) { create(:article) }

        it 'responds with unauthorized status' do
          delete :destroy, id: article
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when user owns article' do
        let!(:article) { create(:article, author: user) }

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
      context 'when user does not own article' do
        let!(:article) { create(:article, author: create(:user)) }

        it 'respond with unauthorized status' do
          get :edit, id: article
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when user owns article' do
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

    describe 'PATCH #update' do
      context 'when user does not own article' do
        let!(:article) { create(:article) }

        it 'responds with unauthorized status' do
          patch :update, id: article.id, article: article_params
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when user does own article' do
        let!(:article) { create(:article, author: user) }

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

  shared_examples 'can manage any article' do
    describe 'DELETE #destroy' do
      it 'deletes the article' do
        article
        expect {
          delete :destroy, id: article
        }.to change(Article, :count).by(-1)
      end

      it 'redirects to articles#index' do
        delete :destroy, id: article
        expect(response).to redirect_to articles_path
      end
    end

    describe 'GET #edit' do
      it 'assigns the article' do
        get :edit, id: article
        expect(assigns(:article)).to eq(article)
      end

      it 'renders the :edit template' do
        get :edit, id: article
        expect(response).to render_template(:edit)
      end
    end

    describe 'PATCH #update' do
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

  context 'as a guest user (not logged in)' do
    it_behaves_like 'can read articles'
    it_behaves_like 'cannot create or manage articles'
  end

  context 'as a logged in member' do
    before(:each) { login_user(user) }

    it_behaves_like 'can read articles'
    it_behaves_like 'can create new articles'
    it_behaves_like 'can manage authored articles only'
  end

  context 'as a logged in admin' do
    let(:user) { create(:admin, session_key: 123) }

    before(:each) { login_user(user) }

    it_behaves_like 'can read articles'
    it_behaves_like 'can create new articles'
    it_behaves_like 'can manage any article'
  end
end
