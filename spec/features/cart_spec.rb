require 'spec_helper'

feature 'Cart'  do

      before(:each) do
        @product0 = FactoryGirl.create(:product)
        @product1 = FactoryGirl.create(:product)
        visit spree.products_path
      end

        it "Empty cart" , :js => true do
          click_link @product0.name
          click_button Spree.t(:add_to_cart)
          click_link Spree.t(:continue_shopping)
          click_link @product1.name
          click_button Spree.t(:add_to_cart)
          click_button Spree.t(:empty_cart)
          page.should have_content(Spree.t(:your_cart_is_empty))
        end
end