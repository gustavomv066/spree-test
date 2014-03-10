require 'spec_helper'

feature 'General links' do
  stub_authorization!

  before(:each) do
    visit spree.admin_path
  end

  scenario "Enter to link Orders", :js => true do
    click_link Spree.t(:orders)
    expect(page).to have_link("admin_new_order")
  end

  scenario "Enter to link Products", :js => true do
    click_link Spree.t(:products)
    expect(page).to have_link("admin_new_product")
  end

  scenario "Enter to link reports", :js => true do
    click_link Spree.t(:reports)
    expect(page).to have_content(Spree.t(:listing_reports))
  end

  scenario "Enter to link configurations", :js => true do
    click_link Spree.t(:configuration)
    expect(page).to have_link(Spree.t(:general_settings))
  end

  scenario "Enter to link Promotions", :js => true do
    click_link Spree.t(:promotions)
    expect(page).to have_link(Spree.t(:new_promotion))
  end

  scenario "Enter to link Users", :js => true do
    click_link Spree.t(:users)
    expect(page).to have_link("admin_new_user_link")
  end



end