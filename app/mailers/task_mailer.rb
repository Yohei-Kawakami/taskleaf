class TaskMailer < ApplicationMailer
    default from: 'taskleaf@example.com'

    def creation_email(task)
        @task = task
        mail(
            subject: 'Task Create Reminder',
            to: 'user@example.com',
            from: 'taskleaf@example.com'
        )
    end
end
