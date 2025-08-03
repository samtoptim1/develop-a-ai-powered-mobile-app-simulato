# asnw_develop_a_ai-po.rb

require 'active_record'
require 'ai4r'

class Simulator < ActiveRecord::Base
  has_many :simulations
  has_many :ai_models

  attribute :name, :string
  attribute :description, :string
  attribute :platform, :string # (iOS, Android)

  validates :name, presence: true
  validates :platform, inclusion: { in: %w(iOS Android) }
end

class Simulation < ActiveRecord::Base
  belongs_to :simulator
  has_many :ai_model_outputs

  attribute :input_data, :string
  attribute :output_data, :string
  attribute :status, :string # (pending, completed, failed)

  validates :input_data, presence: true
end

class AiModel < ActiveRecord::Base
  belongs_to :simulator
  has_many :ai_model_outputs

  attribute :name, :string
  attribute :description, :string
  attribute :model_type, :string # (Neural Network, Decision Tree, etc.)
  attribute :model_data, :string

  validates :name, presence: true
  validates :model_type, presence: true
end

class AiModelOutput < ActiveRecord::Base
  belongs_to :simulation
  belongs_to :ai_model

  attribute :output_data, :string
  attribute :accuracy, :float

  validates :output_data, presence: true
end

# AI Model interface
class AiModelInterface
  def initialize(ai_model)
    @ai_model = ai_model
  end

  def predict(input_data)
    # Call AI model prediction method (e.g. Neural Network, Decision Tree, etc.)
    # Return output data and accuracy
    # For demonstration purposes, return random output and accuracy
    return ["Output data", 0.8]
  end
end

# Simulator API
class SimulatorApi
  def initialize(simulator)
    @simulator = simulator
  end

  def run_simulation(input_data)
    simulation = Simulation.create!(input_data: input_data, simulator: @simulator)
    ai_models = @simulator.ai_models

    ai_models.each do |ai_model|
      output_data, accuracy = AiModelInterface.new(ai_model).predict(input_data)
      AiModelOutput.create!(output_data: output_data, accuracy: accuracy, simulation: simulation, ai_model: ai_model)
    end

    simulation.update!(status: "completed")
  end
end