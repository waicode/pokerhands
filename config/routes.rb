Rails.application.routes.draw do

  # Web
  root 'top#show'
  put '/check', to: 'top#check'

  # API
  namespace 'api' do
    namespace 'v1' do
      post "cards/check" => "cards#check"
    end
  end
  get '*path', to: 'application#render_404'

end
