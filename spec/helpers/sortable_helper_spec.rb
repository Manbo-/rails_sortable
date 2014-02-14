require 'spec_helper'

describe SortableHelper do
  class ARDummy
    alias_method :id, :object_id

    def relation
      Relation.new
    end
  end

  class Relation
    alias_method :id, :object_id
  end

  describe "#sortable_fetch" do
    context "with no block" do
      it { expect { helper.sortable_fetch(Array.new) }.to raise_error }
    end

    context "with block" do
      it "should yield item and its object id" do
        obj = ARDummy.new
        sortable_fetch([ obj ]) do |item, id|
          expect(item).to eq obj
          expect(id).to eq "ARDummy_#{obj.id}"
        end
      end
    end
  end

  describe "#sortable" do
    let(:dummy) do
      ARDummy.new        
    end

    context "with one argument" do
      it do
        expect(sortable([dummy])).to eq [dummy]
      end
    end

    context "with two arguments" do
      it do
        expect(sortable([dummy], :relation)).to be_all{ |res| res.kind_of? Relation }
      end
    end
  end

  describe "#sortable_id" do
    context "when sortable called one arguments" do
      let(:dummy) do
        ARDummy.new        
      end

      before do
        sortable([dummy])
      end

      it do
        expect(sortable_id(dummy)).to eq "ARDummy_#{dummy.id}"
      end
    end

    context "when sortable called two arguments" do
      before do
        @relations = sortable([ARDummy.new], :relation)
      end

      it do
        expect(sortable_id(@relations.first)).to eq "Relation_#{@relations.first.id}"
      end
    end
  end
end
