class ConversationsController < ApplicationController
  def index
    @conversations = []
    Conversation.all.each do |conversation|
      if conversation.sender_id == current_user.id
        @conversations << conversation
      end
      if conversation.recipient_id == current_user.id
        @conversations << conversation
      end
    end

    @conversation = @conversations.last

    begin
      @private_messages = @conversation.private_messages
      if @private_messages.length > 10
        @over_ten = true
        @private_messages = @private_messages[-10..-1]
      end

      if params[:m]
        @over_ten = false
        @private_messages = @conversation.private_messages
      end

      if @private_messages.last
        if @private_messages.last.user_id != current_user.id
          @private_messages.last.read = true;
        end
      end

      @private_message = @conversation.private_messages.new
    rescue
    end

    @conversations.each do |conversation|
      if conversation.sender_id == current_user.id || conversation.recipient_id == current_user.id
        if conversation.sender_id == current_user.id
          @recipient = User.find(conversation.recipient_id)
        else
          @recipient = User.find(conversation.sender_id)
        end
      end
    end
  end

  def show
    @conversations = []
    Conversation.all.each do |conversation|
      if conversation.sender_id == current_user.id
        @conversations << conversation
      end
      if conversation.recipient_id == current_user.id
        @conversations << conversation
      end
    end

    @conversation = Conversation.find(params[:id])

    @conversations.delete(@conversation)

    @conversations << @conversation

    @private_messages = @conversation.private_messages
    if @private_messages.length > 10
      @over_ten = true
      @private_messages = @private_messages[-10..-1]
    end

    if params[:m]
      @over_ten = false
      @private_messages = @conversation.private_messages
    end

    if @private_messages.last
      if @private_messages.last.user_id != current_user.id
        @private_messages.last.read = true;
      end
    end

    @private_message = @conversation.private_messages.new
  end

  def create
    if Conversation.between(params[:sender_id],params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id],
      params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end

    redirect_to conversation_private_messages_path(@conversation)
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end