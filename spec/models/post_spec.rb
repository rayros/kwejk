# == Schema Information
#
# Table name: posts
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  description          :text
#  created_at           :datetime
#  updated_at           :datetime
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  slug                 :string(255)
#  user_id              :integer
#  accepted             :boolean          default(FALSE), not null
#  comment_count        :integer
#  like_count           :integer
#  share_count          :integer
#  total_count          :integer
#
# Indexes
#
#  index_posts_on_slug     (slug) UNIQUE
#  index_posts_on_user_id  (user_id)
#

require 'spec_helper'

describe Post do
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it 'has a valid factory' do
      expect(create(:post)).to be_valid
    end

    describe '#picture' do
      let(:post) { build(:post, picture: nil) }

      it { should have_attached_file(:picture) }
      it { should validate_attachment_presence(:picture) }
      it { should validate_attachment_content_type(:picture).
                           allowing('image/png', 'image/gif').
                           rejecting('text/plain', 'text/xml') }
      it { should validate_attachment_size(:picture).in(0..10.megabytes) }
      
      it 'is nil' do
        expect(post).to_not be_valid
      end

      it 'has correct image styles' do
        styles = Post.attachment_definitions[:picture][:styles]
        expect(styles[:default]).to eq("610x>")
        expect(styles[:thumb]).to eq("100x100>")
      end

    end
  end

  describe 'methods' do
    let(:post) { create(:post) }
    it { is_expected.to respond_to(:accepted!, :not_accepted!) }
    it { is_expected.to respond_to(:hotness) }
    it { is_expected.to respond_to(:should_generate_new_friendly_id?) } 
    it { expect(post.accepted).to be false }
    it '.accepted!' do
      post.accepted!
      expect(post.accepted).to be true
    end
    it '.not_accepted!' do
      post.not_accepted!
      expect(post.accepted).to be false
    end
    it '.hotness' do
      expect(post.hotness).to eq(3)
    end
  end
end
