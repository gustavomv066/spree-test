require 'spec_helper'

feature 'Users'  do
  stub_authorization!

    before(:each) do
      visit spree.admin_users_path
    end

      it "Cancel creation " , :js => true do
        click_link "admin_new_user_link"
        click_link Spree.t(:cancel)
        expect(page).to have_link("admin_new_user_link")
      end

      it "Return to list of users", :js => true  do
        click_link "admin_new_user_link"
        click_link Spree.t(:back_to_users_list)
        expect(page).to have_link("admin_new_user_link")
      end

      it "Create a invalid user (blank fields)", :js => true  do
        click_link "admin_new_user_link"
        click_button Spree.t(:create)
        expect(page).to have_content(I18n::t("activerecord.errors.messages.blank"))
      end

      it "Create a user without @ in his email", :js => true do
        click_link "admin_new_user_link"
        fill_in "user_email", :with =>"email"
        fill_in "user_password", :with =>"password"
        click_button Spree.t(:create)
        expect(page).to have_content(I18n::t("activerecord.errors.messages.invalid"))
      end

      it "Create a user without password confirmation", :js => true do
          click_link "admin_new_user_link"
          fill_in "user_email", :with =>"email@email.com"
          fill_in "user_password", :with =>"password"
          click_button Spree.t(:create)
          expect(page).to have_content(I18n::t("activerecord.errors.messages.confirmation"))
      end

      it "Create a user with password too short", :js => true do
          click_link "admin_new_user_link"
          fill_in "user_email", :with =>"email@email.com"
          fill_in "user_password", :with =>"123"
          fill_in "user_password_confirmation", :with =>"123"
          click_button Spree.t(:create)
          expect(page).to have_content(I18n::t("activerecord.errors.messages.too_short", count: "8"))
      end

      it "Create a valid user", :js => true do
          click_link "admin_new_user_link"
          fill_in "user_email", :with =>"email@email.com"
          fill_in "user_password", :with =>"password"
          fill_in "user_password_confirmation", :with =>"password"
          click_button Spree.t(:create)
          expect(page).to have_content("Created Successfully")
      end

      context "After creation of a user" do

        before(:each) do
          click_link "admin_new_user_link"
          fill_in "user_email", :with =>"email@email.com"
          fill_in "user_password", :with =>"password"
          fill_in "user_password_confirmation", :with =>"password"
          click_button Spree.t(:create)
          expect(page).to have_content("Created Successfully")
        end

        it "Update his email", :js => true do
            fill_in "user_email", :with =>"email0@email.com"
            click_button Spree.t(:update)
            expect(page).to have_field('user_email', :with => 'email0@email.com')
        end

        it "Create a user and generate a key", :js => true do
            click_button "Generate Key"
            expect(page).to have_content('Key Generated')
        end

        context "Generate keys" do

          before(:each) do
            click_button "Generate Key"
            expect(page).to have_content('Key Generated')
          end

          it "Clear a key ", :js => true do
            click_button "Clear Key"
            expect(page).to have_content('Key Cleared')
          end

          it "Regenerated a key ", :js => true do
            click_button "Regenerate Key"
            expect(page).to have_content('Key Generated')
          end

        end

      end
end