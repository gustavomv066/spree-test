require 'spec_helper'

feature 'Configuration'  do
  stub_authorization!

  context "General preferences"do

      before(:each) do
        visit spree.edit_admin_general_settings_path
      end

      it "Cancel update preferences", :js => true  do
          click_link Spree.t(:cancel)
          expect(page).to have_content(Spree.t(:general_settings))
      end

      it "Update preferences", :js => true  do
          fill_in "site_name" , :with => "spree name"
          fill_in "default_seo_title" , :with => "ceo spree"
          fill_in "default_meta_keywords" , :with => "keywords"
          fill_in "default_meta_description" , :with => "description"
          #fill_in "site_url" , :with => "www.spree.com"
          #check "allow_ssl_in_production"
          #check "allow_ssl_in_staging"
          #check "allow_ssl_in_development_and_test"
          #check "check_for_spree_alerts"
          #check "display_currency"
          #check "hide_cents"
          click_button Spree.t(:update)
          expect(page).to have_content(Spree.t(:successfully_updated, resource: "Preferencias en general"))
      end

  end

   context "Preferences methods of email"do

      before(:each) do
        visit spree.edit_admin_mail_method_path
        expect(page).to have_content(Spree.t(:mail_method_settings))
      end

      it "Update preferences", :js => true do
          check "enable_mail_delivery"
          fill_in "mail_domain", :with =>"domain"
          fill_in "mail_host", :with =>"name"
          fill_in "mail_bcc", :with =>"mail bcc"
          fill_in "mail_port", :with =>"mail port"
          fill_in "intercept_email", :with =>"intercept email"
          fill_in "mails_from", :with =>"mail from"
          fill_in "smtp_username", :with =>"smtp"
          fill_in "smtp_password", :with =>"password"
          click_button Spree.t(:update)
          expect(page).to have_content(Spree.t(:successfully_updated, resource: "Métodos de email"))
      end

  end

  context "Images preferences "do

      before(:each) do
        visit spree.edit_admin_image_settings_path
        expect(page).to have_content(Spree.t(:image_settings))
      end

      it "Update images preferences", :js => true  do
          fill_in "preferences_attachment_path", :with =>"attachment path"
          fill_in "preferences_attachment_default_url", :with =>"attachment default url"
          fill_in "preferences_attachment_url", :with =>"attachment url"
          check "preferences_use_s3"
          fill_in "attachment_styles_mini" , :with => "50x50>"
          fill_in "attachment_styles_small" , :with => "50x51>"
          fill_in "attachment_styles_product" , :with => "50x52>"
          fill_in "attachment_styles_large" , :with => "50x53>"
          click_link Spree.t(:add_new_style)
          click_button Spree.t(:update)
          expect(page).to have_content(:image_settings_updated)
      end

  end

  context "Tax category"do

      before(:each) do
        visit spree.admin_tax_categories_path
        expect(page).to have_content(Spree.t(:listing_tax_categories))
      end

      it "Cancel creation of category tax", :js => true  do
          click_link "admin_new_tax_categories_link"
          click_link Spree.t(:cancel)
          expect(page).to have_link("admin_new_tax_categories_link")
      end

      it "Create a invalid category tax", :js => true  do
          click_link "admin_new_tax_categories_link"
          click_button Spree.t(:create)
          expect(page).to have_content(Spree.t(:there_were_problems_with_the_following_fields))
      end

      it "Create a valid category tax", :js => true  do
          click_link "admin_new_tax_categories_link"
          fill_in "tax_category_name", :with =>"name"
          fill_in "tax_category_description", :with =>"description"
          check "tax_category_is_default"
          click_button Spree.t(:create)
          expect(page).to have_content(Spree.t(:successfully_created, resource: "Categoría fiscal \"name\""))
      end

      it "Create a category tax with same name", :js => true  do
          click_link "admin_new_tax_categories_link"
          fill_in "tax_category_name", :with =>"name"
          click_button Spree.t(:create)
          click_link "admin_new_tax_categories_link"
          fill_in "tax_category_name", :with =>"name"
          click_button Spree.t(:create)
          expect(page).to have_content(Spree.t(:there_were_problems_with_the_following_fields))
      end

      it "Don't create a category tax and back", :js => true  do
          click_link "admin_new_tax_categories_link"
          click_link Spree.t(:back_to_tax_categories_list)
          expect(page).to have_link("admin_new_tax_categories_link")
      end

  end

  context "fee tax"do

      before(:each) do
        visit spree.admin_tax_rates_path
        expect(page).to have_content(Spree.t(:tax_rates))
      end

      it "Cancel creation of fee tax", :js => true  do
          click_link Spree.t(:new_tax_rate)
          click_link Spree.t(:cancel)
          expect(page).to have_link(Spree.t(:new_tax_rate))
      end

      it "Create a invalid fee tax (lack arguments)" , :js => true do
          click_link Spree.t(:new_tax_rate)
          click_button Spree.t(:create)
          expect(page).to have_content(Spree.t(:there_were_problems_with_the_following_fields))
      end

      it "Create a invalid fee tax (rate amount as string)" , :js => true do
          click_link Spree.t(:new_tax_rate)
          fill_in "tax_rate_name", :with =>"name"
          fill_in "tax_rate_amount", :with =>"string"
          click_button Spree.t(:create)
          expect(page).to have_content(I18n::t("activerecord.errors.messages.not_a_number"))
      end

      it "Create a invalid fee tax (rate amount as string)" , :js => true do
          click_link Spree.t(:new_tax_rate)
          click_link "Back To Tax Rates List"
          expect(page).to have_link(Spree.t(:new_tax_rate))
      end

       it "Create a valid fee tax" , :js => true do
          @tax_category = FactoryGirl.create(:tax_category)
          click_link Spree.t(:new_tax_rate)
          fill_in "tax_rate_name", :with =>"name"
          fill_in "tax_rate_amount", :with =>"123"
          click_button Spree.t(:create)
          expect(page).to have_content(Spree.t(:successfully_created, resource: "Tasa de impuesto \"name\""))
      end
  end

  context "Tax settings"do

      before(:each) do
         visit spree.edit_admin_tax_settings_path
         expect(page).to have_content(Spree.t(:tax_settings))
      end

      it "Update tax settings" , :js => true do #don't have message post update
        check "preferences_shipment_inc_vat"
        click_button Spree.t(:update)
      end

    end

  context "Zones"do

      before(:each) do
         visit spree.admin_zones_path
         expect(page).to have_content(Spree.t(:zones))
         @state = FactoryGirl.create(:state)
      end

      it "Cancel creation of zone" , :js => true do
          click_link "admin_new_zone_link"
          click_link Spree.t(:cancel)
          expect(page).to have_link("admin_new_zone_link")
      end


      it "Create a invalid zones" , :js => true do
          click_link "admin_new_zone_link"
          click_button Spree.t(:create)
          expect(page).to have_content(I18n::t("activerecord.errors.messages.blank"))
      end

      it "Create a valid zones" , :js => true do
          click_link "admin_new_zone_link"
          fill_in "zone_name", :with =>"name"
          fill_in "zone_description", :with =>"description"
          check "zone_default_tax"
          choose Spree.t(:country_based)
          click_button Spree.t(:create)
          expect(page).to have_content("ha sido creado con éxito")
      end

      it "Create a zones with same name" , :js => true  do
          click_link "admin_new_zone_link"
          fill_in "zone_name", :with =>"name"
          click_button Spree.t(:create)
          click_link "admin_new_zone_link"
          fill_in "zone_name", :with =>"name"
          click_button Spree.t(:create)
          expect(page).to have_content(I18n::t("activerecord.errors.messages.taken"))
      end

      it "Don't create a zone and back", :js => true  do
          click_link "admin_new_zone_link"
          click_link Spree.t(:back_to_zones_list)
          expect(page).to have_link("admin_new_zone_link")
      end

  end

  context "Countries"do

      before(:each) do
         visit spree.admin_countries_path
         expect(page).to have_link("admin_new_country")
      end

      it "Cancel creation of Country" , :js => true do
          click_link "admin_new_country"
          click_link Spree.t(:cancel)
          expect(page).to have_link("admin_new_country")
      end

      it "Create a invalid country" , :js => true do #don't send error message
          click_link "admin_new_country"
          click_button Spree.t(:create)
          expect(page).to have_button(Spree.t(:create))
      end

      it "Create a valid country" , :js => true do
          click_link "admin_new_country"
          fill_in "country_name", :with =>"name"
          fill_in "country_iso_name", :with =>"iso"
          click_button Spree.t(:create)
          expect(page).to have_content(Spree.t(:successfully_created, resource: "País. \"name\""))
      end

      it "Don't create a country and back", :js => true do #wt
          click_link "admin_new_country"
          click_link "Back To Countries List"
          expect(page).to have_link("admin_new_country")
      end

  end

  context "Payment methods"do

      before(:each) do
         visit spree.admin_payment_methods_path
         expect(page).to have_link("admin_new_payment_methods_link")
      end

      it "Create a invalid payment method", :js => true  do
          click_link "admin_new_payment_methods_link"
          click_button Spree.t(:create)
          expect(page).to have_button(Spree.t(:create))
          expect(page).to have_content(I18n::t("activerecord.errors.messages.blank"))
      end

      it "Create a valid payment method", :js => true  do
          click_link "admin_new_payment_methods_link"
          fill_in "payment_method_name", :with =>"name"
          fill_in "payment_method_description", :with =>"description"
          click_button Spree.t(:create)
          expect(page).to have_content(Spree.t(:successfully_created, resource:
            "Método de Pago"))
      end

      it "Don't create a payment method and back", :js => true do
          click_link "admin_new_payment_methods_link"
          click_link Spree.t(:back_to_payment_methods_list)
          expect(page).to have_link("admin_new_payment_methods_link")
      end

  end

   context "Taxonomies"do

      before(:each) do
        visit spree.admin_taxonomies_path
        expect(page).to have_link("admin_new_taxonomy_link")
      end

       it "Create a invalid taxonomy (blank)", :js => true  do
          click_link "admin_new_taxonomy_link"
          click_button Spree.t(:create)
          expect(page).to have_content(I18n::t("activerecord.errors.messages.blank"))
      end

      it "Create a valid taxonomy ", :js => true  do
          click_link "admin_new_taxonomy_link"
          fill_in "taxonomy_name", :with =>"name"
          click_button Spree.t(:create)
          expect(page).to have_content(Spree.t(:successfully_created, resource: "Categoría \"name\""))
      end


      it "Create a taxonomy and update name", :js => true  do
          click_link "admin_new_taxonomy_link"
          fill_in "taxonomy_name", :with =>"name0"
          click_button Spree.t(:create)
          fill_in "taxonomy_name", :with =>"name1"
          click_button Spree.t(:update)
          expect(page).to have_content(Spree.t(:successfully_updated, resource: "Categoría \"name1\""))
      end

      it "Don't create a taxonomy return to taxonomy page", :js => true  do
          click_link "admin_new_taxonomy_link"
          click_link Spree.t(:back_to_taxonomies_list)
          expect(page).to have_link("admin_new_taxonomy_link")
      end
  end

  context "Shipping methods"do

      before(:each) do
        visit spree.admin_shipping_methods_path
        expect(page).to have_link("admin_new_shipping_method_link")
      end

      it "Cancel creation of shipping method", :js => true  do
          click_link "admin_new_shipping_method_link"
          click_link Spree.t(:cancel)
          expect(page).to have_link("admin_new_shipping_method_link")
      end

      it "Don't create a shipping method and back", :js => true  do
          click_link "admin_new_shipping_method_link"
          click_link Spree.t(:back_to_shipping_methods_list)
          expect(page).to have_link("admin_new_shipping_method_link")
      end

      it "Create a invalid shipping method (blank)" , :js => true do
          click_link "admin_new_shipping_method_link"
          click_button Spree.t(:create)
          expect(page).to have_content(I18n::t("activerecord.errors.messages.blank"))
      end

      it "Create a valid shipping method" , :js => true do
          @shipping_category = FactoryGirl.create(:shipping_category)
          @zone = FactoryGirl.create(:zone)
          click_link "admin_new_shipping_method_link"
          fill_in "shipping_method_name", :with =>"name"
          fill_in "shipping_method_admin_name", :with =>"method_name"
          fill_in "shipping_method_tracking_url", :with =>"www.track.com"
          check @shipping_category.name
          check @zone.name
          click_button Spree.t(:create)
          expect(page).to have_content(Spree.t(:successfully_created, resource: "Método de Envío \"name\""))
      end

      context "After creation of a shipping method" do

        before(:each) do
          @shipping_category = FactoryGirl.create(:shipping_category)
          @zone = FactoryGirl.create(:zone)
          click_link "admin_new_shipping_method_link"
          fill_in "shipping_method_name", :with =>"name"
          fill_in "shipping_method_admin_name", :with =>"method_name"
          fill_in "shipping_method_tracking_url", :with =>"www.track.com"
          check @shipping_category.name
          check @zone.name
          click_button Spree.t(:create)
          expect(page).to have_content(Spree.t(:successfully_created, resource: "Método de Envío \"name\""))
        end

        it "Back to shipping methods list" , :js => true do
          click_link Spree.t(:back_to_shipping_methods_list)
          expect(page).to have_link("admin_new_shipping_method_link")
        end

        it "Back to shipping methods list with cancel", :js => true  do
          click_link Spree.t(:cancel)
          expect(page).to have_link("admin_new_shipping_method_link")
        end

        it "Update" , :js => true do
          fill_in "shipping_method_name", :with =>"name0"
          fill_in "shipping_method_admin_name", :with =>"method_name0"
          fill_in "shipping_method_tracking_url", :with =>"www.track0.com"
          check @shipping_category.name
          uncheck @zone.name
          click_button Spree.t(:update)
          expect(page).to have_content(Spree.t(:successfully_updated, resource: "Método de Envío \"name0\""))
        end

        it "Wrong update (without category shipping)" , :js => true do
          fill_in "shipping_method_name", :with =>"name0"
          fill_in "shipping_method_admin_name", :with =>"method_name0"
          fill_in "shipping_method_tracking_url", :with =>"www.track0.com"
          uncheck @shipping_category.name
          uncheck @zone.name
          click_button Spree.t(:update)
          expect(page).to have_content(Spree.t(:there_were_problems_with_the_following_fields))
        end

        it "Wrong update (without name)" , :js => true do

          fill_in "shipping_method_name", :with =>""
          fill_in "shipping_method_admin_name", :with =>"method_name0"
          fill_in "shipping_method_tracking_url", :with =>"www.track0.com"
          check @shipping_category.name
          uncheck @zone.name
          click_button Spree.t(:update)
          expect(page).to have_content(I18n::t("activerecord.errors.messages.blank"))
        end
      end
    end

  context "Shipping category"do

      before(:each) do
        visit spree.admin_shipping_categories_path
        expect(page).to have_link(Spree.t(:new_shipping_category))
      end

       it "Create a invalid shipping category" , :js => true do
          click_link Spree.t(:new_shipping_category)
          click_link Spree.t(:cancel)
          expect(page).to have_link(Spree.t(:new_shipping_category))
      end

      it "Don't create a shipping category return to index page" , :js => true do 
          click_link Spree.t(:new_shipping_category)
          click_link "Back To Shipping Categories List"
          expect(page).to have_button(Spree.t(:new_shipping_category))
      end

      it "Create a valid shipping category" , :js => true do
          click_link Spree.t(:new_shipping_category)
          fill_in "shipping_category_name", :with =>"name"
         click_button Spree.t(:create)
          expect(page).to have_content(Spree.t(:successfully_created, resource: "Categoría de envío \"name\""))
      end
  end

  context "Stock transfers"do
      before(:each) do
         visit spree.admin_stock_transfers_path
         expect(page).to have_link(Spree.t(:new_stock_transfer))
      end

      it "Don't create a stock transfers and back" , :js => true do
          click_link Spree.t(:new_stock_transfer)
          click_link Spree.t(:back_to_stock_transfers_list)
          expect(page).to have_link(Spree.t(:new_stock_transfer))
      end

  end

  context "Stock locations"do #errors lack provincias

      before(:each) do
        visit spree.admin_stock_locations_path
        expect(page).to have_content(Spree.t(:stock_locations))
      end

      context "Stock transfers"  do

        it "Don't create a transfer and back" do
          click_link Spree.t(:new_stock_transfer)
          click_link Spree.t(:back_to_stock_transfers_list)
          expect(page).to have_content(Spree.t(:stock_transfers))
        end

      end

  end

  context "Trackers"do

      before(:each) do
        visit spree.admin_trackers_path
        expect(page).to have_link("admin_new_tracker_link")
      end

       it "Cancel a creation" , :js => true do
          click_link "admin_new_tracker_link"
          click_link Spree.t(:cancel)
          expect(page).to have_link("admin_new_tracker_link")
      end


      it "Don't create and back" , :js => true do
          click_link "admin_new_tracker_link"
          click_link Spree.t(:back_to_trackers_list)
          expect(page).to have_link("admin_new_tracker_link")
      end

      it "Create a valid transfer track" , :js => true do
          click_link "admin_new_tracker_link"
          fill_in "tracker_analytics_id" , :with => "1"
          click_button Spree.t(:create)
          expect(page).to have_content(Spree.t(:successfully_created, resource: "Tracker"))
      end
  end
end
