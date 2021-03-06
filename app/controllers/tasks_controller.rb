class TasksController < ApplicationController
    #before_action :require_user_logged_in, only: [:index, :show]
    before_action :require_user_logged_in
    before_action :set_task, only: [:show, :edit, :update, :destroy]

    
  def index
   #@tasks = Task.all
    if logged_in?
      @user = current_user
      @task = current_user.tasks.build  # form_for 用
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    #@task = Task.new(task_params)
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'タスクが正常に追加されました'
      redirect_to @task
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'タスクが追加されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    
    if @task.update(task_params)
      flash[:success] = 'タスクが正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'タスクは正常に削除されました'
   # redirect_to tasks_url
   redirect_to tasks_url
  end

  private

  def set_task
    #@task = Task.find(params[:id])
    @task = current_user.tasks.find(params[:id])
  end
  
  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
end