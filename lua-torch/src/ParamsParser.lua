  
function ParamsParser()

        --[[ command line arguments ]]--
        cmd = torch.CmdLine()
      
        cmd:text()
        cmd:text('Semantic parsing')
        cmd:text('Options:')
        cmd:text()

        -- training
        cmd:text('Training options')
        cmd:option('--lr', 0.001, 'learning rate - Toc do hoc cua mang ')
        cmd:option('--momentum', 0.95, 'momentum - Giam do dao dong khi hoi tu')
        cmd:option('--decayRate', 0.95, 'decayrate - ')
        cmd:option('--batch_size', 30, 'so cau trong 1 batchInputs')
        cmd:option('--lengWordVector', 300, 'word vector size')
        cmd:option('--lengLabel', 150, 'count label predict')
        cmd:option('--lengDict', 500, 'size Dictionary')
        cmd:option('--maxEpoch', 200, 'so lan lap lai toan bo du lieu')
        cmd:option('--nNumLayerLstmIntermediate', 1, 'count deep lstm layer ')
        cmd:option('--dropoutRate', 0.5, 'rate to drop out')
        cmd:option('--isUsedCuda', true, 'use Cuda gpu')
        cmd:option('--training', false, 'training with data ')
        cmd:option('--testing', false, 'tst with data sample')
        cmd:option('--eval', true, 'run test with new sample ')

        cmd:option('--countLoopOneBatchSize', 5, 'so lan lap lai 1 batchInputs cau')
        cmd:option('--nameNet', "brnnLstm", 'Cai dat ten mang Neron: rnn/rnnLstm/brnnLstm')
        
        -- loging
        cmd:text()
        cmd:text('Loging options')
        cmd:option('--isSaveLog', true, 'Ghi log ra file')
        cmd:option('--nameLog', "log", 'Ten file log')
        cmd:option('--hasTimeLog', false, 'xuat thoi gian trong log')

        cmd:text()


        local opt = cmd:parse(arg or {})

        -- create folder save log
        if(opt.isSaveLog == true) then
                require 'paths'
                
                if (opt.hasTimeLog == true) then
                        cmd:addTime('NER-brnn')
                end
                
                opt.rundir = cmd:string('../logs', {}, {dir=true})
                paths.mkdir(opt.rundir)
                
                opt.nameLog = string.format("%s-%d.log",opt.nameLog, 1 --[[os.time()]]-- 
                )
                cmd:log(opt.rundir .. '/'.. opt.nameLog, opt)

                
        end


        return opt
end
--ParamsParser()
