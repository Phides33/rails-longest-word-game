Rails.application.routes.draw do
  # render the page with a new random grid of words,
  # and the HTML form to write your guess just below the word-grid
  get 'game', to: 'pages#game'

  # should compute and display your score
  get 'score', to: 'pages#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
