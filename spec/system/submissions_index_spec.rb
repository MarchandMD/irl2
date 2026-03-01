require "rails_helper"

RSpec.describe "Submissions index", type: :system do
  before do
    driven_by :rack_test
  end

  let(:user) { create(:user, email: "viewer@example.com") }

  before { sign_in user }

  describe "page header" do
    it "displays the Submissions heading" do
      visit submissions_path
      expect(page).to have_content("Submissions")
      expect(page).to have_content("All task submissions from the community")
    end
  end

  describe "with submissions" do
    let(:task_author) { create(:user) }
    let(:submitter) { create(:user, email: "submitter@example.com") }
    let(:task) { create(:task, user: task_author, title: "Clean the park", description: "Pick up litter in the local park", status: "open") }
    let!(:submission) { create(:user_task, user: submitter, task: task, submission_text: "Cleaned the whole north side!") }

    it "displays the submitter's email prefix" do
      visit submissions_path
      expect(page).to have_content("submitter")
    end

    it "displays the task title as a link" do
      visit submissions_path
      expect(page).to have_link("Clean the park", href: task_path(task))
    end

    it "displays the task description" do
      visit submissions_path
      expect(page).to have_content("Pick up litter in the local park")
    end

    it "displays the submission text" do
      visit submissions_path
      expect(page).to have_content("Cleaned the whole north side!")
    end

    it "displays the task status badge" do
      visit submissions_path
      expect(page).to have_content("open")
    end

    it "displays the time ago" do
      visit submissions_path
      expect(page).to have_content("ago")
    end

    it "links to the submitter's profile" do
      visit submissions_path
      expect(page).to have_link(href: user_path(submitter))
    end
  end

  describe "with multiple submissions" do
    let(:task_author) { create(:user) }
    let(:task1) { create(:task, user: task_author, title: "Task One") }
    let(:task2) { create(:task, user: task_author, title: "Task Two") }

    let!(:older_submission) { create(:user_task, user: create(:user, email: "first@example.com"), task: task1, submission_text: "First submission", created_at: 2.days.ago) }
    let!(:newer_submission) { create(:user_task, user: create(:user, email: "second@example.com"), task: task2, submission_text: "Second submission", created_at: 1.hour.ago) }

    it "displays submissions in reverse chronological order" do
      visit submissions_path
      expect(page.body.index("Second submission")).to be < page.body.index("First submission")
    end

    it "displays all submissions" do
      visit submissions_path
      expect(page).to have_content("Task One")
      expect(page).to have_content("Task Two")
    end
  end

  describe "with no submissions" do
    it "displays the empty state message" do
      visit submissions_path
      expect(page).to have_content("No submissions yet. Be the first to complete a task!")
    end
  end

  describe "submission without submission text" do
    let(:task_author) { create(:user) }
    let(:task) { create(:task, user: task_author, title: "Photo task") }

    it "does not render the submission text section" do
      # Create a user_task without submission_text by skipping validation
      submission = build(:user_task, user: create(:user), task: task, submission_text: nil)
      submission.save!(validate: false)

      visit submissions_path
      expect(page).to have_content("Photo task")
      expect(page).not_to have_css(".bg-gray-50")
    end
  end

  describe "submission without task description" do
    let(:task_author) { create(:user) }

    it "does not render the task description paragraph" do
      task = build(:task, user: task_author, title: "No desc task", description: nil)
      task.save!(validate: false)
      create(:user_task, user: create(:user), task: task, submission_text: "Done!")

      visit submissions_path
      expect(page).to have_content("No desc task")
      expect(page).to have_content("Done!")
    end
  end

  describe "user without profile photo" do
    let(:task_author) { create(:user) }
    let(:task) { create(:task, user: task_author, title: "Some task") }
    let!(:submission) { create(:user_task, user: create(:user), task: task) }

    it "displays the default avatar emoji" do
      visit submissions_path
      expect(page).to have_content("👤")
    end
  end

  context "when not authenticated" do
    before { sign_out user }

    it "redirects to sign in" do
      visit submissions_path
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
