import Foundation
import BigInt

struct GovernanceVoteValidatingParams {
    let assetBalance: AssetBalance?
    let referendum: ReferendumLocal?
    let newVote: ReferendumNewVote?
    let selectedConviction: ConvictionVoting.Conviction?
    let fee: ExtrinsicFeeProtocol?
    let votes: ReferendumAccountVotingDistribution?
    let assetInfo: AssetBalanceDisplayInfo
}
