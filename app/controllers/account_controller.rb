class AccountController < ApplicationController
  before_filter :authenticate_user!, :load_user

  def edit
  end

  def registrations
    @invoices_and_registrations_by_conference = Conference.all.desc(:created_at).reduce({}) do |acc, c|
      registrations_by_product = Registration.booked_for(c).about(current_user).group_by{|r| r.product}
      registrations_by_product.each do |product, list|
        assigned, unassigned = list.reduce([[], []]) {|regs, r| r.user ? regs.first << r : regs.second << r; regs}
        registrations_by_product[product] = [assigned.sort{|a,b| a.user.greeter_name <=> b.user.greeter_name}, unassigned]
      end
      acc[c] = [invoices_for(current_user, c), registrations_by_product]; acc
    end
  end

  def sessions
    @sessions = current_user.sessions.desc(:created_at).paginate(pager_options)
  end

  def update
    flash[:notice] = t('account.updated!') if change_attributes(@user).save
    redirect_to edit_account_path unless request.xhr?
  end

  def destroy
    current_user.destroy
    redirect_to root_path
  end

  private
  def change_attributes(user)
    user.tap do |user|
      user.attributes = params[:user]
      user.optins = (params[:optins] ? params[:optins].keys : [])
      user.company = Company.identified_by_name(params[:company][:name]) if params[:company]
    end
  end
  def load_user
    @user = current_user
  end

  def invoices_for(user, c)
    invoices = Execution.booked_for(c).booked_by(user).map{|e| e.invoice}.uniq.compact
    invoices.each {|invoice| invoice.compute}
  end
end
