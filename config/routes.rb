Rails.application.routes.draw do
  namespace :admin do
    get 'homes/top'
  end
  namespace :public do
    get 'homes/top'
    get 'homes/about'
  end
  # Devise
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions:      "public/sessions"
  }

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # 会員側（/ 直下）
  scope module: :public do
    root "homes#top"
    get  "about" => "homes#about"

    resources :items, only: [:index, :show]

    # 会員情報（マイページ/編集/退会）
    resource :customers, only: [] do
      get   "mypage"             => "customers#show"
      get   "information/edit"   => "customers#edit"
      patch "information"        => "customers#update"
      get   "unsubscribe"        => "customers#unsubscribe"
      patch "withdraw"           => "customers#withdraw"
    end

    # カート
    resources :cart_items, only: [:index, :create, :update, :destroy] do
      collection { delete :destroy_all }  # /cart_items/destroy_all
    end

    # 配送先
    resources :addresses, except: [:show, :new]

    # 注文（確認/サンクスはコレクション）
    resources :orders, only: [:new, :create, :index, :show] do
      collection do
        post :confirm
        get  :thanks
      end
    end
  end

  # 管理者側（/admin 配下）
  namespace :admin do
    root "homes#top"
    resources :items,         except: [:destroy]
    resources :genres,        only:   [:index, :create, :edit, :update]
    resources :customers,     only:   [:index, :show, :edit, :update]
    resources :orders,        only:   [:show, :update]
    resources :order_details, only:   [:update]  # 製作ステータス更新
  end
end

