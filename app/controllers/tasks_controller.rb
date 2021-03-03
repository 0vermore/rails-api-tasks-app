class TasksController < ApiController
    before_action :set_task, only: [:show, :update, :destroy]
    before_action :authorized

    # GET /tasks
    def index
      @tasks = Task.where(user_id: @user.id)
      json_response(@tasks)
    end
  
    # POST /tasks
    def create
      @task = Task.new(task_params)
      @task.user_id = @user.id

      if @task.save
        json_response(@task, :created)
      else
        json_response(@task, :unprocessable_entity)
      end
    end
    
    def show
      json_response(@task)
    end
  
    def update
      Rails.logger.info 'Got task params:'
      Rails.logger.info(task_params)
      @task.update(task_params)
    end
  
    def destroy
      @task.destroy
    end
    
    private
  
      def task_params
        params.require(:task).permit(:title, :description, :priority, :due_date, :completed)
      end
  
      def set_task
        @task = Task.find(params[:id])
      end
end