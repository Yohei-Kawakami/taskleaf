require 'rails_helper'

describe 'task management function', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'user_a', email: 'a@example.com')}
  let(:user_b) { FactoryBot.create(:user, name: 'user_b', email: 'b@example.com')}
  # make a task of user_a
  let!(:task_a) { FactoryBot.create(:task, name: 'first_task', user: user_a) }

  before do
    # log in as user_a
    visit login_path
    fill_in 'Email', with: login_user.email
    fill_in 'Password', with: login_user.password
    click_button 'Login'
  end

  shared_examples_for 'display task of user_a' do
    it { expect(page).to have_content 'first_task' }
  end

  describe 'display ones tasks' do
    context 'when user_a log in' do
      let(:login_user) { user_a }

      it_behaves_like 'display task of user_a'
    end

    context 'when user_b log in' do
      let(:login_user) { user_b }

      it 'display task of user_a' do
        # confirm that all tasks of user_a are not displayed
        expect(page).to have_no_content 'first_task'
      end
    end
  end

  describe 'display detail of task' do
    context 'log in as user_a' do
      let(:login_user) { user_a }

      before do
        visit task_path(task_a)
      end

      it_behaves_like 'display task of user_a'
    end
  end

  describe 'create new account function' do
    let(:login_user) { user_a }
    let(:task_name) { 'test create new task' }

    before do
        visit new_task_path
        fill_in 'Name', with: task_name
        click_button 'Create Task'
    end

    context 'input name version' do
      it 'saved successfully' do
        expect(page).to have_selector '.alert-success', text: 'test create new task'
      end
    end

    context 'input no name version' do
      let(:task_name) { '30over30over30over30over30over30over' } ＃overwrite

      it 'saved not successfully' do
        within '#error_explanation' do
          expect(page).to have_content 'Name is too long'
        end
      end
    end
  end
end



