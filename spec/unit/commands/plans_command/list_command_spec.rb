RSpec.describe ThreeScaleToolbox::Commands::PlansCommand::List::ListSubcommand do
  let(:arguments) do
    {
      service_ref: 'someservice', remote: 'https://destination_key@destination.example.com'
    }
  end
  let(:options) { {} }
  let(:remote) { instance_double('ThreeScale::API::Client', 'remote') }
  let(:service_class) { class_double(ThreeScaleToolbox::Entities::Service).as_stubbed_const }
  let(:service) { instance_double('ThreeScaleToolbox::Entities::Service') }
  let(:plan_a) { instance_double(ThreeScaleToolbox::Entities::ApplicationPlan) }
  let(:plan_b) { instance_double(ThreeScaleToolbox::Entities::ApplicationPlan) }
  let(:plan_c) { instance_double(ThreeScaleToolbox::Entities::ApplicationPlan) }

  subject { described_class.new(options, arguments, nil) }

  context '#run' do
    before :example do
      allow(plan_a).to receive(:attrs).and_return({'system_name' => 'planA'})
      allow(plan_b).to receive(:attrs).and_return({'system_name' => 'planB'})
      allow(plan_c).to receive(:attrs).and_return({'system_name' => 'planC'})
      expect(service_class).to receive(:find).and_return(service)
      expect(subject).to receive(:threescale_client).and_return(remote)
    end

    context 'when service not found' do
      let(:service) { nil }

      it 'error raised' do
        expect { subject.run }.to raise_error(ThreeScaleToolbox::Error,
                                              /Service someservice does not exist/)
      end
    end

    context 'when plan list is returned' do
      let(:plans) { [plan_a, plan_b, plan_c] }

      before :example do
        expect(service).to receive(:plans).and_return(plans)
      end

      it 'plan_a name is shown' do
        expect { subject.run }.to output(/planA/).to_stdout
      end

      it 'plan_b name is shown' do
        expect { subject.run }.to output(/planB/).to_stdout
      end

      it 'plan_c name is shown' do
        expect { subject.run }.to output(/planC/).to_stdout
      end
    end
  end
end
