require 'spec_helper'

describe ItemsController do
  describe 'load datatable' do
    describe 'with default options' do
      before(:each) do
        get :index
      end
      it 'should render the index template' do
        response.should render_template(:index)
      end
    end
  end
end
