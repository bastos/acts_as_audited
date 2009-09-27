require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class AuditsWithPrivateCurrentUsersController < ActionController::Base
  audit Company
  attr_accessor :audit_current_user
    
  def audit
    @company = Company.create
    render :nothing => true
  end
  
  private
  def current_user
    @audit_current_user
  end
end

AuditsWithPrivateCurrentUsersController.view_paths = [File.dirname(__FILE__)]
ActionController::Routing::Routes.draw {|m| m.connect ':controller/:action/:id' }

class AuditsWithPrivateCurrentUsersControllerTest < ActionController::TestCase

  should "call acts as audited on non audited models" do
    Company.should be_kind_of(CollectiveIdea::Acts::Audited::SingletonMethods)
  end
  
  should "audit user" do
    user = @controller.audit_current_user = create_user
    lambda { post :audit }.should change { Audit.count }
    assigns(:company).audits.last.user.should == user
  end
  
end