require 'spec_helper'

feature 'Reports'  do
  stub_authorization!

    before(:each) do
      @product = FactoryGirl.create(:product, :name => "name")
      visit spree.admin_reports_path
    end

    it "Don't search and back ", :js => true do
      click_link Spree.t(:sales_total)
      click_link Spree.t(:back_to_reports_list)
      page.should have_content(Spree.t(:sales_total))
    end



end