require 'spec_helper'

feature 'products'  do
  stub_authorization!

  context "Create products" do

      before(:each) do
        @product = FactoryGirl.create(:product)
        @shipping_category = FactoryGirl.create(:shipping_category)
        @prototype = FactoryGirl.create(:prototype)
        visit spree.admin_path
        click_link Spree.t(:products)
        expect(page).to have_content(Spree.t(:listing_products))

      end

      it "Cancel creation of a product ", :js => true do
        click_link "admin_new_product"
        click_link Spree.t(:cancel)
        expect(page).to have_link("admin_new_product")
      end

      it "Create a invalid product ", :js => true do
        click_link "admin_new_product"
        fill_in "product_name", :with =>"name"
        fill_in "product_price", :with =>"123"
        click_button Spree.t(:create)
        expect(page).to have_content(Spree.t(:error))
      end

      it "Create a valid product ", :js => true do
        click_link "admin_new_product"
        fill_in "product_name", :with =>"name"
        fill_in "product_price", :with =>"123"
        select(@shipping_category.name, :from => Spree.t(:shipping_categories) )
        click_button Spree.t(:create)
        expect(page).to have_content(Spree.t(:successfully_created, resource: "\"name\""))
      end

      it "Create a product with full params ", :js => true  do
        click_link "admin_new_product"
        fill_in "product_name", :with =>"name"
        fill_in "product_sku", :with =>"321"
        select(@prototype.name , :from => Spree.t(:prototype))
        fill_in "product_price", :with =>"123"
        fill_in "product_available_on", :with =>"28/02/2014"
        select(@shipping_category.name, :from => Spree.t(:shipping_categories) )

        click_button Spree.t(:create)
        expect(page).to have_content(Spree.t(:successfully_created, resource: "\"name\""))
      end

  end

  context "After create a product " do

        before (:each) do
          @product = FactoryGirl.create(:product)
          visit spree.admin_products_path
          click_link @product.name
          expect(page).to have_content(Spree.t(:editing_product))
        end

        context "Edit details" do

          it "Don't edit and back " do
            click_link Spree.t(:back_to_products_list)
            expect(page).to have_link("admin_new_product")
          end

        end

        context "Variants" do

          before(:each) do
            click_link Spree.t(:variants)
          end

          it "Cancel ", :js => true do
            click_link Spree.t(:add_one)
            click_link Spree.t(:cancel)
            expect(page).to have_link(Spree.t(:add_one))
          end

          it "Add one ", :js => true do
            click_link Spree.t(:add_one)
            fill_in "variant_sku" , :with => "sku"
            fill_in "variant_price" , :with => "123"
            fill_in "variant_cost_price" , :with => "123"
            fill_in "variant_weight" , :with => "45"
            fill_in "variant_height" , :with => "56"
            fill_in "variant_width" , :with => "34"
            fill_in "variant_depth" , :with => "67"
            click_button Spree.t(:create)
            expect(page).to have_content(Spree.t(:successfully_created, resource: "Variante \"#{@product.name}\""))
          end
        end

        context "Product properties" do

          before(:each) do
            click_link Spree.t(:product_properties)
          end

          it "Update ", :js => true do
            fill_in "product_product_properties_attributes_0_property_name" , :with => "property name"
            fill_in "product_product_properties_attributes_0_value" , :with => "value"
            click_button Spree.t(:update)
            expect(page).to have_content(Spree.t(:successfully_updated, resource: "Producto \"#{@product.name}\""))
          end

        end

        context "Translations"  do

          before(:each) do
            click_link Spree.t("i18n.translations")
          end

            it "Cancel", :js => true do
              click_link Spree.t(:cancel)
              expect(page).to have_link("admin_new_product")
            end

            it "Update ", :js => true do
              fill_in "product_translations_attributes_1_name" , :with => "name"
              click_button Spree.t(:update)
              expect(page).to have_content(Spree.t(:successfully_updated, resource: "Producto \"#{@product.name}\""))
            end
          end
        end

  context "Option Types" do

      before(:each) do
        visit spree.admin_option_types_path
      end

      it "Cancel creation of option type ", :js => true do
        click_link "new_option_type_link"
        click_link Spree.t(:cancel)
        expect(page).to have_link("new_option_type_link")
      end

      it "Create a invalid option type ", :js => true  do
        click_link "new_option_type_link"
        click_button Spree.t(:create)
        expect(page).to have_content(Spree.t(:error))
      end

      it "Create a valid option type ", :js => true do
        click_link "new_option_type_link"
        fill_in "option_type_name", :with =>"name"
        fill_in "option_type_presentation", :with =>"presentation"
        click_button Spree.t(:create)
        expect(page).to have_content(Spree.t(:successfully_created, resource: "\"name\""))
      end

  end

  context "Properties" do

      before(:each) do
        visit spree.admin_properties_path
      end

      it "Cancel creation of option type ", :js => true  do
        click_link "new_property_link"
        fill_in "property_name", :with =>"name0"
        fill_in "property_presentation", :with =>"presentation"
        click_link Spree.t(:cancel)
        expect(page).to have_link("new_property_link")
      end

      it "Create a invalid property ", :js => true  do
        click_link "new_property_link"
        click_button Spree.t(:create)
        expect(page).to have_content(Spree.t(:error))
      end

      it "Create a valid property ", :js => true do
        click_link "new_property_link"
        fill_in "property_name", :with =>"name"
        fill_in "property_presentation", :with =>"presentation"
        click_button Spree.t(:create)
        expect(page).to have_content(Spree.t(:successfully_created, resource: "\"name\""))
      end

  end

  context "Prototypes" do

      before(:each) do
        visit spree.admin_prototypes_path
      end

      it "Cancel creation of a prototype ", :js => true  do
        click_link "new_prototype_link"
        click_link Spree.t(:cancel)
        expect(page).to have_link("new_prototype_link")
      end

      it "Create a invalid prototype ", :js => true  do
        click_link "new_prototype_link"
        click_button Spree.t(:create)
        expect(page).to have_content(Spree.t(:error))
      end

      it "Create a valid prototype ", :js => true do
        click_link "new_prototype_link"
        fill_in "prototype_name", :with =>"name"
        click_button Spree.t(:create)
        expect(page).to have_content(Spree.t(:successfully_created, resource: "\"name\""))
      end

  end
end
