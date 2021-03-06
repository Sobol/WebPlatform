class ProjectSetup
  def initialize(edition: Edition.last, mentor_application: nil, mentee_application: nil)
    raise ActiveRecord::RecordNotFound if (mentor_application.nil? && mentee_application.nil?)

    @edition = edition
    @mentor_application = mentor_application
    @mentee_application = mentee_application
  end

  def create
    ActiveRecord::Base.transaction do
      mentor, mentee = create_user_accounts
      language = @mentee_application.programming_language

      if Project.where(mentor_id: mentor.id, mentee_id: mentee.id).empty?
        Project.create!(language: language,
                        mentor: mentor,
                        mentee: mentee,
                        description: '',
                        title: '',
                        edition: @edition,
                        github_link: nil)
      end
    end
  end

  private

  def create_user_accounts
   mentor = UserCreator.new(edition: @edition).add_mentor(application: @mentor_application)
   mentee = UserCreator.new(edition: @edition).add_mentee(application: @mentee_application)

   [mentor, mentee]
  end
end

