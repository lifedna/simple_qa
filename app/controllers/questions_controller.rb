class QuestionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :search]
  
  def index
    @questions = Question.all
    render :index, :layout => "questions_index"
  end

  def new
    @question = Question.new
    @question.title = params[:keywords]
    render :new, :layout => false
  end

  def create
    @question = current_user.questions.build(params[:question])
    
    if @question.save
      flash[:notice] = "Your question has been submitted successfully!"
      render :json => { :action => 'redirect', :url => question_path(@question) }
    else
      render :json => { :action => 'replace_html', :html => render_to_string('new', :layout => false) }
    end
  end

  def edit
    @question = Question.find_by_slug(params[:id])
  end

  def update
    @question = Question.find_by_slug(params[:id])
    
    if @question.update_attributes(params[:question])
      redirect_to question_path(@question), 
                  :notice => "Your question has been updated successfully!"
    else
      render "edit"
    end
  end

  def show
    @question = Question.find_by_slug(params[:id])
    @answer = @question.answers.build
  end

  def destroy
    @question = Question.find_by_slug(params[:id])
    @question.destroy
    
    redirect_to questions_url, :notice => "Your question has been deleted!"
  end

  def unvote
    @question = Question.find_by_slug(params[:id])
    current_user.unvote(@question)
    redirect_to question_path(@question), :notice => "Your unvote is successfully submitted."
  end

  def vote_up
    @question = Question.find_by_slug(params[:id])
    current_user.vote(@question, :up)
    redirect_to question_path(@question), :notice => "Your vote up is successfully submitted."
  end

  def vote_down
    @question = Question.find_by_slug(params[:id])
    current_user.vote(@question, :down)
    redirect_to question_path(@question), :notice => "Your vote down is successfully submitted."
  end

  def search
    keywords = params[:keywords] ||= ""
    if keywords.strip.blank?
      @questions = Question.all
    else
      @questions = Question.search(params[:keywords])
    end
    render :index, :layout => false
  end
end
