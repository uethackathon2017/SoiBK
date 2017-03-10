require("ParamsParser")
require("Package")
require("Model")

opt = ParamsParser()
model = RnnSemanticParser.model.Seq2Seq()

x1  = torch.Tensor({{0,2,5}, {3,4,5}}):t()
x2  = torch.Tensor({{2,5,6,7,0}, {2,3,4,5,0}}):t()

y = model:forward(x1, x2)
print (y)