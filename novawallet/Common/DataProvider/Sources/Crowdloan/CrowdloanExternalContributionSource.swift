import Foundation
import Operation_iOS

final class ExternalContributionDataProviderSource {
    let children: [ExternalContributionSourceProtocol]
    let accountId: AccountId
    let chain: ChainModel

    init(accountId: AccountId, chain: ChainModel, children: [ExternalContributionSourceProtocol]) {
        self.children = children
        self.accountId = accountId
        self.chain = chain
    }
}

extension ExternalContributionDataProviderSource: SingleValueProviderSourceProtocol {
    typealias Model = [ExternalContribution]

    func fetchOperation() -> CompoundOperationWrapper<Model?> {
        let contributionOperations: [CompoundOperationWrapper<[ExternalContribution]>] = children.map { source in
            source.getContributions(accountId: accountId, chain: chain)
        }

        guard !contributionOperations.isEmpty else {
            return CompoundOperationWrapper.createWithResult([])
        }

        let mergeOperation = ClosureOperation<[ExternalContribution]?> {
            contributionOperations.compactMap { operation in
                try? operation.targetOperation.extractNoCancellableResultData()
            }.flatMap { $0 }
        }

        contributionOperations.forEach { mergeOperation.addDependency($0.targetOperation) }

        let dependencies = contributionOperations.flatMap(\.allOperations)

        return CompoundOperationWrapper(targetOperation: mergeOperation, dependencies: dependencies)
    }
}
