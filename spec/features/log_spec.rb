require 'spec_helper'

feature 'Log'  do
  stub_authorization!

      before(:each) do
        @user = FactoryGirl.create(:user , :email => "email@email.com",
          :password => "password")
        @admin_user = FactoryGirl.create(:admin_user , :email => "emailadmin@email.com", :password => "password")
        visit spree.login_path
      end

        it "Log as normal user" , :js => true do
          fill_in "spree_user_email" , :with => @user.email
          fill_in "spree_user_password" , :with => @user.password
          click_button Spree.t(:login)
          expect(page).to have_content(Spree.t(:logged_in_succesfully))
        end

        context "When a normal user log" do

          before(:each) do
             fill_in "spree_user_email" , :with => @user.email
              fill_in "spree_user_password" , :with => @user.password
              click_button Spree.t(:login)
          end

          it "His account" , :js => true do
            visit spree.account_path
            expect(page).to have_content(@user.email)
          end

          it "Log out" , :js => true do
            visit spree.logout_path
            expect(page).to have_content(I18n::t("devise.user_sessions.signed_out"))
          end

        end

        it "Log as admin" , :js => true do
          fill_in "spree_user_email" , :with => @admin_user.email
          fill_in "spree_user_password" , :with => @admin_user.password
          click_button Spree.t(:login)
          expect(page).to have_content(Spree.t(:logged_in_succesfully))
        end

        context "When a admin user log"  do

          before(:each) do
             fill_in "spree_user_email" , :with => @admin_user.email
             fill_in "spree_user_password" , :with => @admin_user.password
             click_button Spree.t(:login)
          end

          it "His account" , :js => true do
            visit spree.account_path
            expect(page).to have_content(@admin_user.email)
          end

          it "Log out" , :js => true do
            visit spree.logout_path
            expect(page).to have_content(I18n::t("devise.user_sessions.signed_out"))
          end

        end

end