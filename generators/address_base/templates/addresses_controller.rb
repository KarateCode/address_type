class AddressesController < ApplicationController
  before_filter :login_required, :only => [:create_billing]
  # GET /addresses
  # GET /addresses.xml
  def index
    if address_type=="Address"
      @addresses = Address.find(:all)
    else
      @addresses = Address.find_all_by_type(address_type)
    end
    @addresses ||= []

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @addresses }
    end
  end

  # GET /addresses/1
  # GET /addresses/1.xml
  def show
    @address = Address.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @address }
    end
  end

  # GET /addresses/new
  # GET /addresses/new.xml
  def new
    # render :text => controller_name + ", " + address_type
    # return false
    @address = Address.new
    @address_type = address_type
    @user_id = params[:user_id]
    respond_to do |format|
      
      format.html { 
        render :template => 'billing/new' if params[:type] == "billing"
        render :template => 'shipping/new' if params[:type] == "shipping"
      }
      format.xml  { render :xml => @address }
    end
  end

  # GET /addresses/1/edit
  def edit
    @address = Address.find(params[:id])
  end

  # PUT /addresses/1
  # PUT /addresses/1.xml
  def update_shipping_from_purchase
    @address = Address.find(params[:id])

    respond_to do |format|
      if @address.update_attributes(params[:address])
        flash[:notice] = 'Address was successfully updated.'
        format.html { redirect_to( new_payment_path ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit_shipping_from_purchase" }
        format.xml  { render :xml => @address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /addresses
  # POST /addresses.xml
  def create
    @address = Address.new(params[:address])
    @address.type = params[:address][:address_type] unless params[:address][:address_type].blank?
    
    respond_to do |format|
      if @address.save
        flash[:notice] = 'Address was successfully created.'
        format.html { redirect_to( address_path(@address.id) ) }
        format.xml  { render :xml => @address, :status => :created, :location => @address }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @address.errors, :status => :unprocessable_entity }
      end
    end
  end
  def create_billing
    @billing = Billing.new(params[:address])
    respond_to do |format|
      if @billing.save
        flash[:notice] = 'Address was successfully created.'
        if authorized?
          format.html { redirect_to admin_user_path(params[:address][:user_id]) }
        #elsif the user is in the middle of the re-certify payment process
        #  redirect_to  cc processing or shipping info
        else
          format.html { redirect_to( address_path(@billing.id) ) }
          format.xml  { render :xml => @billing, :status => :created, :location => @billing }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @billing.errors, :status => :unprocessable_entity }
      end
    end
  end
  def create_shipping
    @shipping = Shipping.new(params[:address])
    respond_to do |format|
      if @shipping.save
        flash[:notice] = 'Address was successfully created.'
        if authorized?
          format.html { redirect_to admin_user_path(params[:address][:user_id]) }
        end
        format.html { redirect_to( address_path(@shipping.id) ) }
        format.xml  { render :xml => @shipping, :status => :created, :location => @shipping }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shipping.errors, :status => :unprocessable_entity }
      end
    end
  end
    
  
  # PUT /addresses/1
  # PUT /addresses/1.xml
  def update
    @address = Address.find(params[:id])

    respond_to do |format|
      if @address.update_attributes(params[:address])
        flash[:notice] = 'Address was successfully updated.'
        #format.html { redirect_to admin_user_path(@address.user_id) } if authorized?
        format.html { redirect_to( :action=>'show', :id=>@address.id ) } # here we're editing from the user profile; add a conditional for editing from payment process
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.xml
  def destroy
    @address = Address.find(params[:id])
    @address.destroy

    respond_to do |format|
      format.html { redirect_to(:action=>'index') }
      format.xml  { head :ok }
    end
  end
  
  def get_states
     @states = Country.find_by_name(params[:country_name]).states
  end
  
  private
  def address_type  # I should almost name this function model_name or sub_address_type or something...
    dynamic_type = request.env['PATH_INFO'].split("/").reject(&:empty?).first.chomp("addresses").titleize.delete(" ")
    dynamic_type = "Address" if dynamic_type=="Addresses"
    return dynamic_type
  end
end
