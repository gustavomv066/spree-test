require 'spec_helper'

feature 'Promotions'  do
  stub_authorization!


      before(:each) do
        visit spree.admin_promotions_path
        expect(page).to have_content(Spree.t(:promotions))
      end

      it "Cancel creation ", :js => true  do
        click_link Spree.t(:new_promotion)
        click_link Spree.t(:cancel)
        expect(page).to have_link(Spree.t(:new_promotion))
      end

      it "Don't create a promotion and back" , :js => true do
        click_link Spree.t(:new_promotion)
        click_link Spree.t(:back_to_promotions_list)
        expect(page).to have_link(Spree.t(:new_promotion))
      end

      it "Create a invalid promotion (blank)", :js => true do
        click_link Spree.t(:new_promotion)
        click_button Spree.t(:create)
        expect(page).to have_content(I18n::t("activerecord.errors.messages.blank"))
      end

      it "Create a valid promotion" , :js => true do
        click_link Spree.t(:new_promotion)
        fill_in "promotion_name", :with =>"name0"
        fill_in "promotion_description", :with =>"description"
        fill_in "promotion_usage_limit", :with =>"1"
        fill_in "promotion_starts_at", :with =>"27/02/2014"
        fill_in "promotion_expires_at", :with =>"28/02/2014"
        check "promotion_advertise"
        click_button Spree.t(:create)
        expect(page).to have_content(Spree.t(:successfully_created, resource: "Promoción \"name0\""))
      end

      context "After creation of a promotion" do

        before(:each) do
          click_link Spree.t(:new_promotion)
          fill_in "promotion_name", :with =>"name0"
          click_button Spree.t(:create)
        end

        it "Cancel" , :js => true do
          click_link Spree.t(:cancel)
          expect(page).to have_link(Spree.t(:new_promotion))
        end

        it "Back to list" , :js => true do
          click_link Spree.t(:back_to_promotions_list)
          expect(page).to have_link(Spree.t(:new_promotion))
        end

      end

end