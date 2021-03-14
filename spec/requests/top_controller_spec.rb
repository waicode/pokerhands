require 'rails_helper'

describe TopController, :type => :request do

  describe 'GET #show' do

    before do
      @path = '/'
    end

    describe 'Render' do

      it "renders the :show template" do
        get @path
        expect(response.body).to include "Check a Porker Hand"
      end

    end

  end

  describe 'POST #check' do

    before do
      @path = '/check'
    end

    describe 'Redirect' do

      describe 'OK' do
        it "rendirects to the :show " do
          get @path, params: { cards: "S1 H2 D3 C4 H12" }
          expect(response).to redirect_to(:root)
        end
      end

      describe 'Alert' do
        it "rendirects to the :show " do
          put @path, params: { cards: "A B C D E" }
          expect(response).to redirect_to(:root)
        end
      end

    end

  end

end