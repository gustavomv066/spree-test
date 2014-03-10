require 'spec_helper'

feature 'Orders'  do
  stub_authorization!

    before(:each) do
      @product = FactoryGirl.create(:product, :name => "name")
      visit spree.admin_orders_path
    end

    context "New order " do

      before(:each) do
        click_link "admin_new_order"
      end

      it "Don't create a order and back", :js => true do
          click_link Spree.t(:back_to_orders_list)
          expect(page).to have_link("admin_new_order")
      end

      context "Client details" do

        before(:each) do
          click_link Spree.t(:customer_details)
        end

        it "Blank update" , :js => true do
          click_button Spree.t(:update)
          expect(page).to have_content(I18n::t("activerecord.errors.messages.blank"))
        end

        it "Update", :js => true do
          fill_in "order_email" , :with => "email@email.com"
          fill_in "order_bill_address_attributes_firstname" , :with => "name"
          fill_in "order_bill_address_attributes_lastname" , :with => "lastname"
          fill_in "order_bill_address_attributes_address1" , :with => "address1"
          fill_in "order_bill_address_attributes_address2" , :with => "address2"
          fill_in "order_bill_address_attributes_city" , :with => "city"
          fill_in "order_bill_address_attributes_zipcode" , :with => "zipcode"
          fill_in "order_bill_address_attributes_phone" , :with => "phone"
          click_button Spree.t(:update)
          expect(page).to have_content(Spree.t(:customer_details_updated))
        end

        context "Payment" do

          before(:each) do
            fill_in "order_email" , :with => "email@email.com"
            fill_in "order_bill_address_attributes_firstname" , :with => "name"
            fill_in "order_bill_address_attributes_lastname" , :with => "lastname"
            fill_in "order_bill_address_attributes_address1" , :with => "address1"
            fill_in "order_bill_address_attributes_address2" , :with => "address2"
            fill_in "order_bill_address_attributes_city" , :with => "city"
            fill_in "order_bill_address_attributes_zipcode" , :with => "zipcode"
            fill_in "order_bill_address_attributes_phone" , :with => "phone"
            click_button Spree.t(:update)
            click_link Spree.t(:payments)
          end

          it "Back to payment list", :js => true do
            pending("Looks like doesn't work in Spree.")
            click_link Spree.t(:back_to_payments_list)
            expect(page).to have_link(Spree.t(:admin_new_order))
          end
        end
      end

      context "Adjustment" do

        before(:each) do
          click_link Spree.t(:adjustments)
        end

        it "Back to orders list", :js => true do
          click_link Spree.t(:back_to_orders_list)
          expect(page).to have_link("admin_new_order")
        end

        it "Cancel creation", :js => true do
          click_link Spree.t(:new_adjustment)
          click_link Spree.t(:cancel)
          expect(page).to have_link(Spree.t(:new_adjustment))
        end

        it "Invalid creation (blank)", :js => true do
          click_link Spree.t(:new_adjustment)
          click_button Spree.t(:continue)
          expect(page).to have_content(I18n::t("activerecord.errors.messages.blank"))
        end

        it "Invalid creation amount is not number", :js => true do
          click_link Spree.t(:new_adjustment)
          fill_in "adjustment_amount" , :with => "amount"
          fill_in "adjustment_label"  , :with => "label"
          click_button Spree.t(:continue)
          expect(page).to have_content(I18n::t("activerecord.errors.messages.not_a_number"))
        end

        it "Invalid creation amoun is not number", :js => true do
          click_link Spree.t(:new_adjustment)
          fill_in "adjustment_amount" , :with => "123"
          fill_in "adjustment_label"  , :with => "label"
          click_button Spree.t(:continue)
          expect(page).to have_content(Spree.t(:successfully_created, resource: "Adjustment"))
        end
      end
  end
end