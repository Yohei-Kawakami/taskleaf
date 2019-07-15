class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page]).recent.per(20)

    respond_to do |format|
      format.html
      format.csv { send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv" }
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to task_url, notice: "Updated '#{@task.name}'"
    else
      redirect_to task_url, notice: "Failed to update '#{@task.name}'"
    end
  end

  def create
    @task = current_user.tasks.new(task_params)

    if params[:back].present?
      render :new
      return
    end
      if @task.save
        TaskMailer.creation_email(@task).deliver_now
        # SampleJob.perform_later
        logger.debug "task: #{@task.attributes.inspect}"
        redirect_to @task, notice: "Saved '#{@task.name}'"
      else
        render :new
      end
  end

  def destroy
    @task.destroy!
    # head :no_content
    if params[:type] == 'show'
      redirect_to @task, notice: "Deleted '#{@task.name}'"
    end
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  def import
    if params[:file].present?
      current_user.tasks.import(params[:file])
      redirect_to tasks_url, notice: "Added　a Task"
    else
      redirect_to tasks_url, notice: "Please Select a CSV"
    end
  end

  private

    def task_params
      params.require(:task).permit(:name, :description, :image)
    end

    def set_task
      @task = current_user.tasks.find(params[:id])
    end
end
